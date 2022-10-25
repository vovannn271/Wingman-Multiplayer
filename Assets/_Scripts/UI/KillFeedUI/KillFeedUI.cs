using System.Collections;
using System.Collections.Generic;
using Opsive.Shared.Events;
using Opsive.Shared.Game;
using UnityEngine;

public class KillFeedUI : MonoBehaviour
{
    [SerializeField] GameObject killListingPrefab;
    [SerializeField] Sprite[] howImages;//TODO

    private void Start()
    {
        EventHandler.RegisterEvent<string, string>( "OnKill", OnKill);
    }

    private void OnKill(string killer, string killed)
    {
        Debug.Log( "Registered Event" );
        GameObject temp = ObjectPool.Instantiate( killListingPrefab, transform);
        temp.transform.SetSiblingIndex( 0 );
        KillListing tempListing = temp.GetComponent<KillListing>();
        tempListing.SetNames( killer, killed );
    }

    private void OnDestroy()
    {
        EventHandler.UnregisterEvent<string, string>( "OnKill", OnKill );
    }
}
