using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InGameUIController : MonoBehaviour
{
    [SerializeField] private GameObject _playerDeathPanel;
    [SerializeField] private GameObject _playerAlivePanel;
    [SerializeField] private GameObject _playerWonPanel;
    private void Awake()
    {
        _playerDeathPanel.SetActive( false );
        _playerAlivePanel.SetActive( true );
    }


    public void ShowUIOnPlayerDeath()
    {
        _playerDeathPanel.SetActive( true );
        _playerAlivePanel.SetActive( false );
    }




}
