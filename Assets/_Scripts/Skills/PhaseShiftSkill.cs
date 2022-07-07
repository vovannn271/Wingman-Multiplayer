using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Opsive.UltimateCharacterController.Character.Abilities;

public class PhaseShiftSkill : Ability
{
    [SerializeField] private GameObject particlesOnShift;
    [SerializeField] private float cooldown = 3f;
    [SerializeField] private float durationTime = 3f;

    
    private float startTime;
    private bool collisionLayerEnabled;
    private GameObject currentParticlesObject;

    public override bool CanStartAbility()
    {
        if (!base.CanStartAbility())
        {
            return false;
        }

        //Add coldown
  
        return true;
    }

    public override void Update()
    {
        base.Update();

        if (!this.IsActive)
        {
            return;
        }     
        
        if (Time.time > startTime + durationTime)
            {
                Debug.Log( "stopping" );
                StopAbility();

         }
        
       

    }
    protected override void AbilityStarted()
    {
        startTime = Time.time;
        base.AbilityStarted();
        currentParticlesObject = GameObject.Instantiate( particlesOnShift, this.m_GameObject.transform );
        
            
        collisionLayerEnabled = m_CharacterLocomotion.CollisionLayerEnabled;
        m_CharacterLocomotion.EnableColliderCollisionLayer( false );
    }

    protected override void AbilityStopped( bool force )
    {
        base.AbilityStopped( force );
        m_CharacterLocomotion.EnableColliderCollisionLayer( collisionLayerEnabled );
        GameObject.Destroy( currentParticlesObject );
    }



}
