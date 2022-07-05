using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Character.Abilities;
public class ChangeGravitySkill : Ability
{
    private float sizeOfCharacter = 2f;
    private bool m_Stopping;
    private bool m_StoppingFromUpdate = false;

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
        m_Stopping = false;
        m_StoppingFromUpdate = false;
    }

    public override void UpdateRotation()
    {
        Vector3 targetNormal;

        if ( m_Stopping == false)
        {
            targetNormal = -m_CharacterLocomotion.GravityDirection;
            targetNormal.Normalize();
            Rotate( targetNormal );
        }
        else
        {
            m_Transform.eulerAngles = new Vector3(
            m_Transform.transform.eulerAngles.x + 180,
            m_Transform.transform.eulerAngles.y,
            m_Transform.transform.eulerAngles.z
);
        }
        


    }

    public override void WillTryStopAbility()
    {
        base.WillTryStopAbility();
        m_Stopping = true;
    }

    public override void LateUpdate()
    {
        base.LateUpdate();

        // The ability should be stopped within LateUpdate so the character has a chance to be rotated.
        if (m_Stopping)
        {
            m_StoppingFromUpdate = true;
            StopAbility();
            m_StoppingFromUpdate = false;
        }
    }


    protected override void AbilityStopped( bool force )
    {
        base.AbilityStopped( force );


        Vector3 tPos = m_Transform.position;
        m_Transform.position = new Vector3( tPos.x, tPos.y - sizeOfCharacter, tPos.z );

        m_CharacterLocomotion.GravityDirection *= -1;
    }





    public override bool CanStopAbility()
    {
        // Don't stop until the character is oriented in the correct direction.
        if (m_StoppingFromUpdate)
        {
            return true;
        }

        return false;
    }
    public void Rotate( Vector3 targetNormal )
    {
        var deltaRotation = Quaternion.Euler( m_CharacterLocomotion.DeltaRotation );
        var rotation = m_Transform.rotation * deltaRotation;
        var proj = ( rotation * Vector3.forward ) - ( Vector3.Dot( ( rotation * Vector3.forward ), targetNormal ) ) * targetNormal;
        if (proj.sqrMagnitude > 0.0001f)
        {
            Quaternion targetRotation;
            if (m_CharacterLocomotion.Platform == null)
            {
                var alignToGroundSpeed = 100 * m_CharacterLocomotion.TimeScale * Time.timeScale * Time.deltaTime;
                targetRotation = Quaternion.Slerp( rotation, Quaternion.LookRotation( proj, targetNormal ), alignToGroundSpeed );
            }
            else
            {
                targetRotation = Quaternion.LookRotation( proj, targetNormal );
            }
            deltaRotation = deltaRotation * ( Quaternion.Inverse( rotation ) * targetRotation );
            m_CharacterLocomotion.DeltaRotation = deltaRotation.eulerAngles;
        }
        else
        {
            // Prevents locking the rotation if proj magnitude is close to 0 when character forward is close or equal to targetNormal.
            var right = rotation * Vector3.right;
            var forward = Vector3.Cross( right, targetNormal );
            var targetRotation = Quaternion.LookRotation( forward, targetNormal );
            deltaRotation = deltaRotation * ( Quaternion.Inverse( rotation ) * targetRotation );
            m_CharacterLocomotion.DeltaRotation = deltaRotation.eulerAngles;
        }
    }
}