#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace HeneGames.CookingSystem.Editor
{
    [CustomEditor(typeof(SlicedFood))]
    public class SlicedFoodEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();

            SlicedFood yourComponent = (SlicedFood)target;

            GUILayout.Space(10);

            if (GUILayout.Button("Setup Start Collider"))
            {
                yourComponent.EditorSetupBoxcolliderStart();
            }

            if (GUILayout.Button("Setup End Collider"))
            {
                yourComponent.EditorSetupBoxColliderEnd();
            }

            if (GUILayout.Button("Show Start Collider"))
            {
                yourComponent.EditorShowStartCollider();
            }

            if (GUILayout.Button("Show End Collider"))
            {
                yourComponent.EditorShowEndCollider();
            }
        }
    }
}
#endif