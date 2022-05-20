using ExitGames.Client.Photon;
using Photon.Realtime;
using Photon.Pun;

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MultiplayerSpawn : MonoBehaviour, IOnEventCallback
{

    byte CustomManualInstantiationEventCode = 100;
    public GameObject PlayerPrefab;

    private void Update()
    {
        if ( Input.GetKeyDown(KeyCode.K))
        {
            Debug.Log( "key pressed" );
            SpawnPlayer();
        }
    }



    private void OnEnable()
    {
        PhotonNetwork.AddCallbackTarget( this );
    }

    private void OnDisable()
    {
        PhotonNetwork.RemoveCallbackTarget( this );
    }


    public void SpawnPlayer()
    {
            GameObject player = Instantiate( PlayerPrefab );

        PhotonView photonView = player.GetComponent<PhotonView>();
        if (photonView == null)
        {
            Debug.Log( "adding photon view " );
            photonView = player.AddComponent<PhotonView>();
        }

            if (PhotonNetwork.AllocateViewID( photonView ))
            {
                object[] data = new object[]
                {
            player.transform.position, player.transform.rotation, photonView.ViewID
                };

                RaiseEventOptions raiseEventOptions = new RaiseEventOptions {
                    Receivers = ReceiverGroup.Others,
                    CachingOption = EventCaching.AddToRoomCache
                };

                SendOptions sendOptions = new SendOptions {
                    Reliability = true
                };

                PhotonNetwork.RaiseEvent( CustomManualInstantiationEventCode, data, raiseEventOptions, sendOptions );
            Debug.Log( "Event raised " + CustomManualInstantiationEventCode );    
        }
            else
            {
                Debug.LogError( "Failed to allocate a ViewId." );

                Destroy( player );
            }        

    }

    public void OnEvent( EventData photonEvent )
    {
            Debug.Log( "Event received" + CustomManualInstantiationEventCode );
        if (photonEvent.Code == CustomManualInstantiationEventCode)
        {
            object[] data = (object[])photonEvent.CustomData;

            GameObject objectInstantiated = (GameObject)Instantiate( PlayerPrefab, (Vector3)data[0], (Quaternion)data[1] );
            PhotonView photonView = objectInstantiated.GetComponent<PhotonView>();
            photonView.ViewID = (int)data[2];
        }
    }


}
