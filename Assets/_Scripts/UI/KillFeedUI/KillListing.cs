using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class KillListing : MonoBehaviour
{
    [SerializeField] TMP_Text killerDisplay;
    [SerializeField] TMP_Text killedDisplay;

    [SerializeField] Image howImageDisplay;

    private void Start()
    {
        Destroy( gameObject, 10f );
    }

    public void SetNames( string killerName, string killedName )
    {
        killerDisplay.text = killerName;
        killedDisplay.text = killedName;
    }

    //TODO  SetNamesANDHOWImage
}
