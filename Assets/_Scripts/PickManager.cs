using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class PickManager : MonoBehaviour
{
    
    public void SetPickedHero( int heroId = 0 )
    {
        var hash = PhotonNetwork.LocalPlayer.CustomProperties;
        hash.Add( "heroId", heroId );
        PhotonNetwork.LocalPlayer.SetCustomProperties( hash );
    }
}
