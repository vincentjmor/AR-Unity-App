using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace HeneGames.CookingSystem
{
    public class FoodCollider : MonoBehaviour
    {
        [SerializeField] private Food foodScript;
        [SerializeField] private SlicedFood slicedFood;
        [SerializeField] private Rigidbody rb;

        public Food FoodScript()
        {
            return foodScript;
        }

        public Rigidbody Rigidbody()
        {
            return rb;
        }

        public SlicedFood SlicedFood()
        {
            return slicedFood;
        }
    }
}