using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickManager : MonoBehaviour
{
    public string m_SceneName;

    public static int PickedHeroId { get; private set; }
    public void PickHero( int heroId )
    {
        PickedHeroId = heroId;        
    }

    public void LoadLevel()
    {
        PhotonNetwork.LoadLevel( m_SceneName );
    }
}
