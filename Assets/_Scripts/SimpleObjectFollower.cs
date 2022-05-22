using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleObjectFollower : MonoBehaviourPun, IPunObservable
{
    [SerializeField] 
    private GameObject _brush;

    private void OnEnable()
    {
        PhotonNetwork.AddCallbackTarget( this );
    }

    private void OnDisable()
    {
        PhotonNetwork.RemoveCallbackTarget( this );
    }


    public void OnPhotonSerializeView( PhotonStream stream, PhotonMessageInfo info )
    {
        if (stream.IsWriting)
        {
            stream.SendNext( transform.position );
            Debug.Log( "writing" );
        }
        else if (stream.IsReading)
        {
            Debug.Log( (Vector3)stream.ReceiveNext() );
            //_brush.transform.position = (Vector3)
        }

    }
}

