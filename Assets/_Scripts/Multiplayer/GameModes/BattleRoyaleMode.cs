using Opsive.Shared.Events;
using Photon.Pun;
using Photon.Realtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Traits;
public class BattleRoyaleMode : MonoBehaviour
{
    private int _numberOfPlayers = 0;
    
    public enum GameStage
    {
        Preparing,
        Beggining,
        End
    }

    private void Start()
    {
        EventHandler.RegisterEvent<string, string>( "OnKill", OnKill );

    }
    private void OnKill( string a, string b )
    {
        _numberOfPlayers = 0;

        var photonViews = UnityEngine.Object.FindObjectsOfType<PhotonView>();
        foreach (var view in photonViews)
        {
            var player = view.Owner;
            //Objects in the scene don't have an owner, its means view.owner will be null
            if (player != null)
            {
                if (view.gameObject.GetComponent<CharacterHealth>().IsAlive())
                {
                    _numberOfPlayers++;
                }
            }
        }


    }
    // Update is called once per frame
    void Update()
    {
        /*foreach (Player player in PhotonNetwork.PlayerList)
        {
            print( player.NickName );
        }*/

    }
}
