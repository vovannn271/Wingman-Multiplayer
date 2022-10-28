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

public class BattleRoyaleMode : MonoBehaviourPunCallbacks, IOnEventCallback
{
    private int _amountOfAlive = 0;
    private SpawnManager _spawnManager;

    private GameStage _gameStage = GameStage.Preparing;

    //For BeforeGame Countdown
    private bool startTimer = false;
    private double timerIncrementValue;
    private double startTime;
    ExitGames.Client.Photon.Hashtable CustomeValue;
    [SerializeField] private double timer = 20;

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


    }

    private void Start()
    {
        EventHandler.RegisterEvent<string, string>( "OnKill", OnKill );

        StartBeforeGameCountdown();
        PreparingToTheGame();
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
            startTimer = false;
            object[] data = new object[1];
            data[0] = GameStage.GameStart;

            PhotonNetwork.RaiseEvent( PhotonEventIDs.GameStageChanged,
                data,
                new RaiseEventOptions() { CachingOption = EventCaching.AddToRoomCache, Receivers = ReceiverGroup.All},
                SendOptions.SendReliable );
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
    }

    private void StartTheGame()
    {
        GameObject player = _spawnManager.Player;
        
        if ( player != null)
        {
            UltimateCharacterLocomotion locomotion = player.GetComponent<UltimateCharacterLocomotion>();
            //locomotion.MovingSpeedParameterValue = 0;
            locomotion.UseRootMotionPosition = false;
            locomotion.RootMotionSpeedMultiplier = 1;
        }
    }

    private void PreparingToTheGame()
    {
        GameObject player = _spawnManager.Player;
        UltimateCharacterLocomotion locomotion = player.GetComponent<UltimateCharacterLocomotion>();
        //locomotion.MovingSpeedParameterValue = 0;
        locomotion.UseRootMotionPosition = true;
        locomotion.RootMotionSpeedMultiplier = 0;
    }

}
