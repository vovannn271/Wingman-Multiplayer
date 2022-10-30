using Opsive.Shared.Events;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
public class AmountAliveUI : MonoBehaviour
{
    [SerializeField] private TMP_Text aliveAmountTMP;
    private void Awake()
    {
        aliveAmountTMP.text = "";
        EventHandler.RegisterEvent<int>( "OnAliveAmountChanged", OnAliveAmountChanged );
    }

    private void OnAliveAmountChanged( int amount )
    {
        aliveAmountTMP.text = "Players left: " + amount;
    }

    private void OnDestroy()
    {
        EventHandler.UnregisterEvent<int>( "OnAliveAmountChanged", OnAliveAmountChanged );
    }
}
