using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OfflineMode : MonoBehaviour
{
    private void Awake()
    {
        if (!Application.isEditor)
        {
            gameObject.SetActive( false );
        }
    }
    public void TurnOnOfflineMode()
    {
        PhotonNetwork.OfflineMode = true;
    }
}
