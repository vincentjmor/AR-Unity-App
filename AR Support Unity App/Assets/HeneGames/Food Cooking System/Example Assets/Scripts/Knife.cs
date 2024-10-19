using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace HeneGames.CookingSystem.Examples
{
    public class Knife : MonoBehaviour
    {
        float slice;

        private void Update()
        {
            if(slice > 0f)
            {
                slice -= Time.deltaTime;
            }
        }

        private void OnCollisionEnter(Collision _collision)
        {
            if(_collision.gameObject.TryGetComponent<SlicedFood>(out SlicedFood _slicedFood))
            {
                if (slice <= 0f)
                {
                    _slicedFood.Slice();
                    slice = 0.1f;
                }
            }
        }
    }
}