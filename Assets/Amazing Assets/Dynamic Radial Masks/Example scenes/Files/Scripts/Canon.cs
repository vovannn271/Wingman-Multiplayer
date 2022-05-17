using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace AmazingAssets
{
    namespace DynamicRadialMasks
    {
        public class Canon : MonoBehaviour
        {
            public GameObject prefab;
            public float impulseStrength = 1;

            void Update()
            {
                if (Input.GetMouseButtonDown(0))
                {
                    Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);


                    GameObject go = GameObject.Instantiate(prefab);
                    go.SetActive(true);
                    go.hideFlags = HideFlags.HideInHierarchy;
                    go.transform.position = ray.origin - Vector3.up;
                    go.GetComponent<Rigidbody>().AddForce(ray.direction.normalized * impulseStrength, ForceMode.Impulse);
                }
            }
        }
    }
}
