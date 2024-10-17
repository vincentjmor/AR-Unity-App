using HeneGames.CookingSystem;
using TMPro;
using UnityEngine;

namespace HeneGames.CookingSystem.Examples
{
    public class FoodValuesExample : MonoBehaviour
    {
        float lastCookedPercent;
        float lastCookedPercentTimer;
        bool flipFood;

        [Header("Foof class reference")]
        [SerializeField] private Food food;

        [Header("Text objects")]
        [SerializeField] private TextMeshProUGUI foodStatusText;
        [SerializeField] private TextMeshProUGUI cookedPercentText;
        [SerializeField] private TextMeshProUGUI burnedPercentText;
        [SerializeField] private TextMeshProUGUI cookedBooleanText;
        [SerializeField] private TextMeshProUGUI burnedBooleanText;

        private void Update()
        {
            //Code works only if references are setup
            if (food == null)
                return;
            if (foodStatusText == null)
                return;
            if (burnedPercentText == null)
                return;
            if (cookedPercentText == null)
                return;
            if (cookedBooleanText == null)
                return;
            if (burnedBooleanText == null)
                return;

            //Follow food model
            transform.position = food.transform.position;

            FoodStatusUpdate();
            FoodValuesUpdate();
        }

        private void FoodStatusUpdate()
        {
            //Status text
            if (food.IsBurned())
            {
                foodStatusText.color = Color.red;
                foodStatusText.text = "Burned";
            }
            else if (food.IsReady())
            {
                foodStatusText.color = Color.green;
                foodStatusText.text = "Ready";
            }
            else if (food.ItsCooking() && !flipFood)
            {
                foodStatusText.color = Color.cyan;
                foodStatusText.text = "Cooking";
            }
            else if (food.ItsCooking() && flipFood)
            {
                foodStatusText.color = Color.red;
                foodStatusText.text = "Flip Food";
            }
            else
            {
                foodStatusText.color = Color.green;
                foodStatusText.text = "Not in heat source";
            }

            //Flip or not boolean logic
            if (lastCookedPercent == food.CookedPercent())
            {
                if(lastCookedPercentTimer < 1f)
                {
                    lastCookedPercentTimer += Time.deltaTime;
                }
                else
                {
                    flipFood = true;
                }
            }
            else
            {
                flipFood = false;
                lastCookedPercentTimer = 0f;
                lastCookedPercent = food.CookedPercent();
            }
        }

        private void FoodValuesUpdate()
        {
            cookedPercentText.text = "Cooked: " + food.CookedPercent().ToString("F1") + "%";
            burnedPercentText.text = "Burned: " + food.BurnedPercent().ToString("F1") + "%";

            cookedBooleanText.text = "Cooked = " + food.IsReady().ToString();
            burnedBooleanText.text = "Burned = " + food.IsBurned().ToString();
        }
    }
}