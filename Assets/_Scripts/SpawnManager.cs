using ExitGames.Client.Photon;
using Opsive.Shared.Events;
using Opsive.Shared.Game;
using Opsive.UltimateCharacterController.AddOns.Multiplayer.PhotonPun;
using Opsive.UltimateCharacterController.AddOns.Multiplayer.PhotonPun.Game;
using Opsive.UltimateCharacterController.Character;
using Opsive.UltimateCharacterController.Game;
using Photon.Pun;
using Photon.Realtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnManager : SpawnManagerBase
{
    [Tooltip( "A reference to the character that PUN should spawn. This character must be setup using the PUN Multiplayer Manager." )]
    [SerializeField] protected GameObject m_Character;
    public GameObject Character { get { return m_Character; } set { m_Character = value; } }
    [SerializeField] protected GameObject brushPrefab;
    private GameObject _brushGO;


    private void Awake()
    {
        
    }
    public override void Start()
    {
        _brushGO = PhotonNetwork.Instantiate( brushPrefab.name, new Vector3( 0f, 5f, 0f ), Quaternion.identity, 0 );
        base.Start();

    }
    protected override GameObject GetCharacterPrefab( Player newPlayer )
    {
        // Return the same character for all instances.
        return m_Character;
    }


    public override void SpawnPlayer( Player newPlayer )
    {
        // Only the master client can spawn new players.
        if (!PhotonNetwork.IsMasterClient)
        {
            return;
        }

        var determineSpawnLocation = true;
        var spawnPosition = Vector3.zero;
        var spawnRotation = Quaternion.identity;

        InactivePlayer inactivePlayer;
        if (m_InactivePlayers != null && m_InactivePlayers.TryGetValue( newPlayer, out inactivePlayer ))
        {
            // The player has rejoined the game. The character does not need to go through the full spawn procedure.
            Scheduler.Cancel( inactivePlayer.RemoveEvent );
            m_InactivePlayers.Remove( newPlayer );

            // The spawn location is determined by the last disconnected location.
            spawnPosition = inactivePlayer.Position;
            spawnRotation = inactivePlayer.Rotation;
            determineSpawnLocation = false;
        }

        // Spawn the new player based on the spawn mode.
        if (determineSpawnLocation)
        {
            if (m_Mode == SpawnMode.SpawnPoint)
            {
                if (!SpawnPointManager.GetPlacement( null, m_SpawnPointGrouping, ref spawnPosition, ref spawnRotation ))
                {
                    Debug.LogWarning( $"Warning: The Spawn Point Manager is unable to determine a spawn location for grouping {m_SpawnPointGrouping}. " +
                                     "Consider adding more spawn points." );
                }
            }
            else
            {
                if (m_SpawnLocation != null)
                {
                    spawnPosition = m_SpawnLocation.position;
                    spawnRotation = m_SpawnLocation.rotation;
                }
                spawnPosition += m_PlayerCount * m_SpawnLocationOffset;
            }
        }

        // Instantiate the player and let the PhotonNetwork know of the new character.
        Player = GameObject.Instantiate( GetCharacterPrefab( newPlayer ), spawnPosition, spawnRotation );
        var photonView = _player.GetComponent<PhotonView>();

        photonView.ViewID = PhotonNetwork.AllocateViewID( newPlayer.ActorNumber );
        if (photonView.ViewID > 0)
        {
            // As of PUN 2.19, when the ViewID is allocated the Owner is not set. Set the owner to null and then to the player so the owner will correctly be assigned.
            photonView.TransferOwnership( null );
            photonView.TransferOwnership( newPlayer );

            // The character has been created. All other clients need to instantiate the character as well.
            var data = new object[]
            {
                    _player.transform.position, _player.transform.rotation, photonView.ViewID, newPlayer.ActorNumber
            };
            m_RaiseEventOptions.TargetActors = null;
            PhotonNetwork.RaiseEvent( PhotonEventIDs.PlayerInstantiation, data, m_RaiseEventOptions, m_ReliableSendOption );

            // The new player should instantiate all existing characters in addition to their character.
            if (newPlayer != PhotonNetwork.LocalPlayer)
            {
                // Deactivate the character until the remote machine has the chance to create it. This will prevent the character from
                // being active on the Master Client without being able to be controlled.
                _player.SetActive( false );

                data = new object[m_PlayerCount * 4];
                for (int i = 0; i < m_PlayerCount; ++i)
                {
                    data[i * 4] = m_Players[i].transform.position;
                    data[i * 4 + 1] = m_Players[i].transform.rotation;
                    data[i * 4 + 2] = m_Players[i].ViewID;
                    data[i * 4 + 3] = m_Players[i].Owner.ActorNumber;
                }
                m_RaiseEventOptions.TargetActors = new int[] { newPlayer.ActorNumber };
                PhotonNetwork.RaiseEvent( PhotonEventIDs.PlayerInstantiation, data, m_RaiseEventOptions, m_ReliableSendOption );
            }
            else
            {
                //Getting brush for drawing skill for first, main Player
                UltimateCharacterLocomotion characterLocomotion = _player.GetCachedComponent<UltimateCharacterLocomotion>();
                DrawingSkill drawingSkill = characterLocomotion.GetAbility<DrawingSkill>();
                drawingSkill.Brush = _brushGO.GetComponent<PUNMeshPaint>();
                drawingSkill.CurrentPlayerPhotonView = photonView;




            }

            AddPhotonView( photonView );
            EventHandler.ExecuteEvent( "OnPlayerEnteredRoom", photonView.Owner, photonView.gameObject );
        }
        else
        {
            Debug.LogError( "Failed to allocate a ViewId." );
            Destroy( _player );
        }




    }





    public override void OnEvent( EventData photonEvent )
    {
        if (photonEvent.Code == PhotonEventIDs.PlayerInstantiation)
        {
            // The Master Client has instantiated a character. Create that character on the local client as well.
            var data = (object[])photonEvent.CustomData;
            for (int i = 0; i < data.Length / 4; ++i)
            {
                var viewID = (int)data[i * 4 + 2];
                if (PhotonNetwork.GetPhotonView( viewID ) != null)
                {
                    continue;
                }

                var player = PhotonNetwork.CurrentRoom.GetPlayer( (int)data[i * 4 + 3] );
                character = Instantiate( GetCharacterPrefab( player ), (Vector3)data[i * 4], (Quaternion)data[i * 4 + 1] );

                var photonView = character.GetCachedComponent<PhotonView>();
                photonView.ViewID = viewID;
                // As of PUN 2.19, when the ViewID is set the Owner is not set. Set the owner to null and then to the player so the owner will correctly be assigned.
                photonView.TransferOwnership( null );
                photonView.TransferOwnership( player );
                AddPhotonView( photonView );


                UltimateCharacterLocomotion characterLocomotion = character.GetCachedComponent<UltimateCharacterLocomotion>();

                // If the instantiated character is a local player then the Master Client is waiting for it to be created on the client. Notify the Master Client
                // that the character has been created so it can be activated.
                if (photonView.IsMine)
                {
                    Debug.Log( "spawn player" + photonView.ViewID );
                    m_RaiseEventOptions.TargetActors = new int[] { PhotonNetwork.MasterClient.ActorNumber };
                    PhotonNetwork.RaiseEvent( PhotonEventIDs.RemotePlayerInstantiationComplete, photonView.Owner.ActorNumber, m_RaiseEventOptions, m_ReliableSendOption );

                    //setting up Drawing Skill for spawned character
                    DrawingSkill drawingSkill = characterLocomotion.GetAbility<DrawingSkill>();
                    drawingSkill.Brush = _brushGO.GetComponent<PUNMeshPaint>();
                    drawingSkill.CurrentPlayerPhotonView = photonView;
                }
                else
                {
                    // Call start manually before any events are received. This ensures the remote character has been initialized.
                    characterLocomotion.Start();
                }
                EventHandler.ExecuteEvent( "OnPlayerEnteredRoom", photonView.Owner, photonView.gameObject );
            }
        }
        else if (photonEvent.Code == PhotonEventIDs.RemotePlayerInstantiationComplete)
        {
            // The remote player has instantiated the character. It can now be enabled (on the Master Client).
            var ownerActor = (int)photonEvent.CustomData;
            for (int i = 0; i < m_PlayerCount; ++i)
            {
                if (m_Players[i].Owner.ActorNumber == ownerActor)
                {
                    m_Players[i].gameObject.SetActive( true );
                    break;
                }
            }
        }


    }
}
