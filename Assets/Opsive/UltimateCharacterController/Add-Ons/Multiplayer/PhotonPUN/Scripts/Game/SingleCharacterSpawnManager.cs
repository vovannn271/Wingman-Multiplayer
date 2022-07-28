﻿/// ---------------------------------------------
/// Ultimate Character Controller
/// Copyright (c) Opsive. All Rights Reserved.
/// https://www.opsive.com
/// ---------------------------------------------

namespace Opsive.UltimateCharacterController.AddOns.Multiplayer.PhotonPun.Game
{
    using UnityEngine;
    using Photon.Realtime;
    using Photon.Pun;
    using ExitGames.Client.Photon;
    using Opsive.UltimateCharacterController.Character;

    /// <summary>
    /// Manages the character instantiation within a PUN room.
    /// </summary>
    public class SingleCharacterSpawnManager : SpawnManagerBase
    {
        [Tooltip("A reference to the character that PUN should spawn. This character must be setup using the PUN Multiplayer Manager.")]
        [SerializeField] protected GameObject m_Character;
        public GameObject Character { get { return m_Character; } set { m_Character = value; } }
        [SerializeField] protected GameObject brushPrefab;
        private GameObject _brushGO;



        public override void Start()
        {
            base.Start();

            _brushGO = PhotonNetwork.Instantiate( brushPrefab.name, new Vector3( 0f, 5f, 0f ), Quaternion.identity, 0 );
            //  UltimateCharacterLocomotion ucl = _player.GetComponent<UltimateCharacterLocomotion>();
            //   ucl.GetAbility<DrawingSkill>().Brush = _brushGO.GetComponent<PUNMeshPaint>();
            //

        }


        /// <summary>
        /// Abstract method that allows for a character to be spawned based on the game logic.
        /// </summary>
        /// <param name="newPlayer">The player that entered the room.</param>
        /// <returns>The character prefab that should spawn.</returns>
        protected override GameObject GetCharacterPrefab(Player newPlayer)
        {
            // Return the same character for all instances.
            return m_Character;
        }


    }
}