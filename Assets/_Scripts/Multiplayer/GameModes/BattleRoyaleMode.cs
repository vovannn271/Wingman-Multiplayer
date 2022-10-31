using Opsive.Shared.Events;
using Photon.Pun;
using Photon.Realtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Traits;
using Opsive.UltimateCharacterController.AddOns.Multiplayer.PhotonPun;
using ExitGames.Client.Photon;
using Opsive.UltimateCharacterController.Character;
using Opsive.UltimateCharacterController.AddOns.Multiplayer.PhotonPun.Character;
using Opsive.Shared.Game;
using Opsive.UltimateCharacterController.Character.Abilities;
using Opsive.UltimateCharacterController.Camera;

public class BattleRoyaleMode : MonoBehaviourPunCallbacks, IOnEventCallback
{
    private SpawnManager _spawnManager;
    private PunCharacter _localPunCharacter;
    private CameraController _cameraController;
    private InGameUIController _inGameUIController;


    //GameMode logic vars
    private int _amountOfAlive = 0;
    private GameStage _gameStage = GameStage.Preparing;
    //For BeforeGame Countdown
    private bool startTimer = false;
    private double timerIncrementValue;
    private double startTime;
    ExitGames.Client.Photon.Hashtable CustomeValue;
    [SerializeField] private double timer = 10d;

    public enum GameStage
    {
        Preparing,
        GameStart,
        ZoneShrinking,
        GameEnd
    }

    private void Awake()
    {
        _spawnManager = FindObjectOfType<SpawnManager>();
        _cameraController = FindObjectOfType<CameraController>();
        _inGameUIController = FindObjectOfType<InGameUIController>();

        EventHandler.RegisterEvent<Player, GameObject>( "OnPlayerEnteredRoom", OnPlayerEnteredRoom );
        EventHandler.RegisterEvent<Player, GameObject>( "OnPlayerLeftRoom", OnPlayerLeftRoom );
        EventHandler.RegisterEvent<int>( "OnAliveAmountChanged", OnAliveAmountChanged );
        EventHandler.RegisterEvent<string, string>( "OnKill", OnKill );


    }

    private void OnDeath( Vector3 position, Vector3 force, GameObject attacker )
    {
        _cameraController.ChangeAnchorToOtherPlayer( attacker );
        _inGameUIController.ShowUIOnPlayerDeath();
    }

    private void Start()
    {
        StartBeforeGameCountdown();
    }


    private void Update()
    {
        if (!startTimer)
            return;

       // Debug.Log( timer - timerIncrementValue );
        timerIncrementValue = PhotonNetwork.Time - startTime;

        if (timerIncrementValue >= timer)
        {
            Debug.Log( "timer ended" );
            startTimer = false;
            object[] data = new object[1];
            data[0] = GameStage.GameStart;

            PhotonNetwork.RaiseEvent( PhotonEventIDs.GameStageChanged,
                data,
                new RaiseEventOptions() { CachingOption = EventCaching.AddToRoomCache, Receivers = ReceiverGroup.All},
                SendOptions.SendReliable );
        }    


    }








    #region ModeLogic
    private void StartBeforeGameCountdown()
    {
        if (PhotonNetwork.LocalPlayer.IsMasterClient)
        {
            CustomeValue = new ExitGames.Client.Photon.Hashtable();
            startTime = PhotonNetwork.Time;
            startTimer = true;
            CustomeValue.Add( "StartTime", startTime );
            PhotonNetwork.CurrentRoom.SetCustomProperties( CustomeValue );
        }
        else
        {
         //   startTime = double.Parse( PhotonNetwork.CurrentRoom.CustomProperties["StartTime"].ToString() );
          //  startTimer = true;
        }

    }



    public void OnEvent( EventData photonEvent )
    {
        if ( photonEvent.Code == PhotonEventIDs.GameStageChanged)
        {
            object[] data = (object[])photonEvent.CustomData;
            _gameStage = (GameStage)data[0];

            switch (_gameStage)
            {
                case GameStage.GameStart:
                    StartTheGame();
                    break;
                

                default:
                break;
            }       
        }
        else if ( photonEvent.Code == PhotonEventIDs.AliveAmountChanged)
        {
            object[] data = (object[])photonEvent.CustomData;
            int newAmount = (int)data[0];
            EventHandler.ExecuteEvent<int>( "OnAliveAmountChanged", newAmount );
        }
    }

    private void StartTheGame()
    {
        if (_localPunCharacter == null)
        {
            _localPunCharacter = _spawnManager.Player.GetCachedComponent<PunCharacter>();
        }
        
        if ( _gameStage == GameStage.Preparing)
        {
            _gameStage = GameStage.GameStart;
        }

        if (_localPunCharacter != null)
        {
            WaitAfkAbility afkAbility = _localPunCharacter.CharacterLocomotion.GetAbility<WaitAfkAbility>();
            _localPunCharacter.CharacterLocomotion.TryStopAbility( afkAbility );
            Debug.Log( "Start the Game" );
        }

        if (PhotonNetwork.IsMasterClient)
        {
            RecountAlivePlayers();
        }
    }


    private void PreparingToTheGame()
    {
        WaitAfkAbility afkAbility = _localPunCharacter.CharacterLocomotion.GetAbility<WaitAfkAbility>();
        _localPunCharacter.CharacterLocomotion.TryStartAbility( afkAbility );
    }

    private void OnPlayerEnteredRoom( Player player, GameObject character )
    {
        if( player.IsLocal != true)
        {
            return;
        }
        _localPunCharacter = character.GetCachedComponent<PunCharacter>();
        EventHandler.RegisterEvent( _localPunCharacter.gameObject, "OnRespawn", OnRespawn );
        EventHandler.RegisterEvent<Vector3, Vector3, GameObject>( _localPunCharacter.gameObject, "OnDeath", OnDeath );


        if ( _gameStage == GameStage.Preparing)
        {
            Debug.Log( "Preparing To Game Stage" );

             PreparingToTheGame();
        }
    }

    private void OnPlayerLeftRoom( Player player, GameObject character )
    {
        if (!PhotonNetwork.IsMasterClient)
        {
            return;
        }
        if (character.GetCachedComponent<Health>().IsAlive())
        {
            RecountAlivePlayers();
        }
    }

    #endregion





    private void OnKill( string killer, string killed )
    {
        if (PhotonNetwork.IsMasterClient)
        {
            RecountAlivePlayers();
        }
    }


    private void OnRespawn()
    {
        if (PhotonNetwork.IsMasterClient)
        {
            RecountAlivePlayers();
        }
    }

    private void RecountAlivePlayers()
    {
        if (!PhotonNetwork.IsMasterClient)
        {
            return;
        }

        int aliveAm = 0;
        foreach (var playerView in _spawnManager.PlayersViews)
        {
            if (playerView == null)
            {
                continue;
            }
            CharacterHealth health = playerView.gameObject.GetComponent<CharacterHealth>();
            if (health != null && health.IsAlive())
            {
                aliveAm++;
            }
        }
        if ( _amountOfAlive != aliveAm)
        {
            object[] data = new object[1];
            data[0] = aliveAm;

            PhotonNetwork.RaiseEvent( PhotonEventIDs.AliveAmountChanged,
                data,
                new RaiseEventOptions() { Receivers = ReceiverGroup.All },
                SendOptions.SendReliable );
        }
    }

    
    private void OnAliveAmountChanged( int newAmount)
    {
        _amountOfAlive = newAmount;
        Debug.Log( "new amount of alive players: " + newAmount );
    }

    private void OnDestroy()
    {
        EventHandler.UnregisterEvent<Player, GameObject>( "OnPlayerEnteredRoom", OnPlayerEnteredRoom );
        EventHandler.UnregisterEvent<Player, GameObject>( "OnPlayerLeftRoom", OnPlayerLeftRoom );
        EventHandler.UnregisterEvent<int>( "OnAliveAmountChanged", OnAliveAmountChanged );
        EventHandler.UnregisterEvent<string, string>( "OnKill", OnKill );
        if ( _localPunCharacter != null)
        {
            EventHandler.UnregisterEvent( _localPunCharacter.gameObject, "OnRespawn", OnRespawn );
            EventHandler.UnregisterEvent<Vector3, Vector3, GameObject>( _localPunCharacter.gameObject, "OnDeath", OnDeath );
            
        }
        else
        {
            Debug.Log( "local character is already destroyed, can not unregister event" );
        }
        

    }

}
