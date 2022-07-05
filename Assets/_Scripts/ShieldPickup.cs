using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Traits;
using Opsive.Shared.Game;
using Opsive.UltimateCharacterController.Objects.CharacterAssist;

    [RequireComponent( typeof( AttributeManager ) )]
    public class ShieldPickup : ObjectPickup
    {
        [Tooltip( "The amount of shield to replenish." )]
        [SerializeField] private float m_ShieldAmount = 40;
        [Tooltip( "Should the object be picked up even if the object has full shield?" )]
        [SerializeField] private bool m_AlwaysPickup;

        public float ShieldAmount { get { return m_ShieldAmount; } set { m_ShieldAmount = value; } }
        public bool AlwaysPickup { get { return m_AlwaysPickup; } set { m_AlwaysPickup = value; } }

        /// <summary>
        /// A GameObject has entered the trigger.
        /// </summary>
        /// <param name="other">The GameObject that entered the trigger.</param>
        public override void TriggerEnter( GameObject other )
        {
            DoPickup( other );
        }

        /// <summary>
        /// Picks up the object.
        /// </summary>
        /// <param name="target">The object doing the pickup.</param>
        public override void DoPickup( GameObject target )
        {
            var health = target.GetCachedParentComponent<Health>();
            if (health != null && health.IsAlive())
            {
                if (health.HealShield( m_ShieldAmount ) || m_AlwaysPickup)
                {
                    ObjectPickedUp( health.gameObject );
                }
            }
        }
    }
