using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class PickManager : MonoBehaviour
{
    
    public void SetPickedHero( int heroId = 0 )
    {
        var hash = PhotonNetwork.LocalPlayer.CustomProperties;
        if (!hash.ContainsKey( "heroId" ))
        {
            hash.Add( "heroId", heroId );
        }
        else
        {
            PhotonNetwork.LocalPlayer.CustomProperties["heroId"] = heroId;
        }
        PhotonNetwork.LocalPlayer.SetCustomProperties( hash );
    }
}
