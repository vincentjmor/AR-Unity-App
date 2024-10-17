using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace HeneGames.CookingSystem
{
    public class HeatSource : MonoBehaviour
    {
        private List<Food> foodList = new List<Food>();

        [Header("Settings")]
        public CookingSystemType cookingSystemType;
        [Range(0.01f, 1f)]
        public float cookingStrenghtMultiplier = 0.1f;
        public bool isHeatSourceOn;

        [Header("If cooking system type is Deep Fryer")]
        public Transform oilSurface;

        private void OnTriggerEnter(Collider other)
        {
            for (int i = 0; i < foodList.Count; i++)
            {
                if (foodList[i] == null)
                {
                    foodList.RemoveAt(i);
                }
            }

            if (other.gameObject.TryGetComponent<FoodCollider>(out FoodCollider _foodCollider))
            {
                Food _food = _foodCollider.FoodScript();

                _food.AddToHeatSource(this);

                if(!FoodAlreadyInList(_food))
                {
                    foodList.Add(_food);
                }
            }
        }

        private void OnTriggerExit(Collider other)
        {
            for (int i = 0; i < foodList.Count; i++)
            {
                if (foodList[i] == null)
                {
                    foodList.RemoveAt(i);
                }
            }

            if (other.gameObject.TryGetComponent<FoodCollider>(out FoodCollider _foodCollider))
            {
                Food _food = _foodCollider.FoodScript();

                _food.AddToHeatSource(null);

                foodList.Remove(_food);
            }
        }

        private bool FoodAlreadyInList(Food _food)
        {
            for (int i = 0; i < foodList.Count; i++)
            {
                if(_food == foodList[i])
                {
                    return true;
                }
            }

            return false;
        }

        public List<Food> FoodList()
        {
            for (int i = 0; i < foodList.Count; i++)
            {
                if (foodList[i] == null)
                {
                    foodList.RemoveAt(i);
                }
            }

            return foodList;
        }
    }
}