using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Character.Abilities;
public class ChangeGravitySkill : Ability
{
    private float sizeOfCharacter = 2f;
    private AlignToGravityZone m_AlignToGravityZone;
    public override bool CanStartAbility()
    {
        // An attribute may prevent the ability from starting.
        if (!base.CanStartAbility())
        {
            return false;
        }

        return m_CharacterLocomotion != null;
    }

    public override void Start()
    {
        for (int i = 0; i < m_CharacterLocomotion.Abilities.Length; ++i)
        {
                // The MoveTowards and ItemToggleAbilityBlock abilities are a special type of ability in that it is started by the controller.
                if (m_CharacterLocomotion.Abilities[i] is AlignToGravityZone)
                {
                    m_AlignToGravityZone = m_CharacterLocomotion.Abilities[i] as AlignToGravityZone;
                }
            }
    }



   public override bool IsConcurrent { get { return true; } }

    protected override void AbilityStarted()
    {
        base.AbilityStarted();

        //to stop teleporting through textures
        // Vector3 tPos = m_Transform.position;
        // m_Transform.position = new Vector3( tPos.x, tPos.y + sizeOfCharacter, tPos.z );
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
