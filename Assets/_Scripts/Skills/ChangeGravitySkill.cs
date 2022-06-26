using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Character.Abilities;
public class ChangeGravitySkill : Ability
{
    private float sizeOfCharacter = 2f;
    public override bool CanStartAbility()
    {
        // An attribute may prevent the ability from starting.
        if (!base.CanStartAbility())
        {
            return false;
        }

        return m_CharacterLocomotion != null;
    }

   public override bool IsConcurrent { get { return true; } }

    protected override void AbilityStarted()
    {
        base.AbilityStarted();
        
        //to stop teleporting through textures
        Vector3 tPos = m_Transform.position;
        m_Transform.position = new Vector3( tPos.x, tPos.y + sizeOfCharacter, tPos.z );

        m_CharacterLocomotion.GravityDirection *= -1;
    }

    protected override void AbilityStopped( bool force )
    {
        base.AbilityStopped( force );
        Vector3 tPos = m_Transform.position;
        m_Transform.position = new Vector3( tPos.x, tPos.y - sizeOfCharacter, tPos.z );

        m_CharacterLocomotion.GravityDirection *= -1;
    }
}
