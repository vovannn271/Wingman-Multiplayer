using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisablePhotonConnection : MonoBehaviour
{
    // Start is called before the first frame update
    void Awake()
    {
        PhotonNetwork.OfflineMode = true;

    }

}
