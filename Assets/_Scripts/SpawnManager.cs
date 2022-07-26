using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.AddOns.Multiplayer.PhotonPun.Game;
using Photon.Realtime;
using Photon.Pun;
using Opsive.UltimateCharacterController.Character;

/// <summary>
/// Manages the character instantiation within a PUN room.
/// </summary>
public class SpawnManager : SpawnManagerBase
    {
        [Tooltip( "A reference to the character that PUN should spawn. This character must be setup using the PUN Multiplayer Manager." )]
        [SerializeField] protected GameObject _character;

        [SerializeField] protected GameObject brushPrefab;
        private GameObject _brushGO;


    public override void Start()
    {
        base.Start();
        _brushGO = PhotonNetwork.Instantiate( brushPrefab.name, new Vector3( 0f, 5f, 0f ), Quaternion.identity, 0 );
        Player.GetComponent<UltimateCharacterLocomotion>().GetAbility<DrawingSkill>().Brush = _brushGO.GetComponent<PUNMeshPaint>();
        //Player.GetComponent<DrawingSkill>().Brush = _brushGO.GetComponent<PUNMeshPaint>();
    }







    public GameObject Character { get { return _character; } set { _character = value; } }
    public GameObject Brush { get { return _brushGO; } private set {} }

        /// <summary>
        /// Abstract method that allows for a character to be spawned based on the game logic.
        /// </summary>
        /// <param name="newPlayer">The player that entered the room.</param>
        /// <returns>The character prefab that should spawn.</returns>
        protected override GameObject GetCharacterPrefab( Player newPlayer )
        {
            // Return the same character for all instances.
            return _character;
        }




    }