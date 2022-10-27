using Opsive.Shared.Events;
using Photon.Pun;
using Photon.Realtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Traits;
using Opsive.UltimateCharacterController.AddOns.Multiplayer.PhotonPun;
using ExitGames.Client.Photon;

public class BattleRoyaleMode : MonoBehaviour
{
    private int _amountOfAlive = 0;
    private SpawnManager _spawnManager;


    //For BeforeGame Countdown
    private bool startTimer = false;
    private double timerIncrementValue;
    private double startTime;
    [SerializeField] private double timer = 20;
    ExitGames.Client.Photon.Hashtable CustomeValue;


    public enum GameStage
    {
        Preparing,
        Beggining,
        End
    }

    private void Awake()
    {
        _spawnManager = FindObjectOfType<SpawnManager>();
    }

    private void Start()
    {
        EventHandler.RegisterEvent<string, string>( "OnKill", OnKill );

        StartBeforeGameCountdown();
    }


    private void Update()
    {
        if (!startTimer)
            return;

        Debug.Log( timer - timerIncrementValue );
        timerIncrementValue = PhotonNetwork.Time - startTime;

        if (timerIncrementValue >= timer)
        {
            Debug.Log( "timer ended" );
        }
    }






    private void OnKill( string a, string b )
    {
        int aliveAm = 0;
        foreach( var playerView in _spawnManager.PlayersViews)
        {
            if ( playerView == null)
            {
                continue;
            }
            CharacterHealth health = playerView.gameObject.GetComponent<CharacterHealth>();
            if ( health != null && health.IsAlive())
            {
                aliveAm++;
            }
        }
        Debug.Log( aliveAm );
        _amountOfAlive = aliveAm;
    }

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
            startTime = double.Parse( PhotonNetwork.CurrentRoom.CustomProperties["StartTime"].ToString() );
            startTimer = true;
        }

    }
}
