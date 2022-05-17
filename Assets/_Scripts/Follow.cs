using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Follow : MonoBehaviour
{
    [SerializeField] private GameObject _track;
    private Transform _cachedTrans;
    private Vector3 _cachedPos;

    void Start()
    {
        _cachedTrans = GetComponent<Transform>();
        if (_track.transform)
        {
            _cachedPos = _track.transform.position;
        }
    }

    void LateUpdate()
    {
        if (_track && _cachedPos != _track.transform.position)
        {
            _cachedPos = _track.transform.position;
            transform.position = _cachedPos;
        }
    }
}
