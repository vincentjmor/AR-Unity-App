using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace HeneGames.CookingSystem
{
    public class SlicedFood : MonoBehaviour
    {
        Vector3 sliceSpawnerStartPosition;
        Food food;

        [Header("Slice references")]
        [SerializeField] private bool sliceDebug;
        [SerializeField] private SkinnedMeshRenderer slicedFoodRenderer;
        [SerializeField] private BoxCollider boxCollider;
        [SerializeField] private Food slicePrefab;
        [SerializeField] private Transform sliceSpawner;
        [SerializeField] private Transform sliceSpawnerEndPosition;

        [Header("Slice settings")]
        public int howManySliced;
        [SerializeField] private int sliceCount = 10;

        [Header("Use buttons to control these values")]
        [SerializeField] private Vector3 boxColliderStartCenter;
        [SerializeField] private Vector3 boxColliderStartSize;
        [SerializeField] private Vector3 boxColliderEndCenter;
        [SerializeField] private Vector3 boxColliderEndSize;

        private void Awake()
        {
            food = GetComponent<Food>();
        }

        private void Start()
        {
            sliceSpawnerStartPosition = sliceSpawner.localPosition;
        }

        public void EditorSetupBoxcolliderStart()
        {
            boxColliderStartCenter = boxCollider.center;
            boxColliderStartSize = boxCollider.size;
        }

        public void EditorSetupBoxColliderEnd()
        {
            boxColliderEndCenter = boxCollider.center;
            boxColliderEndSize = boxCollider.size;

            boxCollider.center = boxColliderStartCenter;
            boxCollider.size = boxColliderStartSize;

            slicedFoodRenderer.SetBlendShapeWeight(0, 0f);
        }

        public void EditorShowStartCollider()
        {
            boxCollider.center = boxColliderStartCenter;
            boxCollider.size = boxColliderStartSize;

            slicedFoodRenderer.SetBlendShapeWeight(0, 0f);
        }

        public void EditorShowEndCollider()
        {
            boxCollider.center = boxColliderEndCenter;
            boxCollider.size = boxColliderEndSize;

            slicedFoodRenderer.SetBlendShapeWeight(0, 100f);
        }

        private void Update()
        {
            if(sliceDebug)
            {
                Slice();
                sliceDebug = false;
            }
        }

        public bool CanSlice()
        {
            if (howManySliced == sliceCount)
            {
                return false;
            }

            return true;
        }

        public void Slice()
        {
            if (howManySliced == sliceCount)
                return;

            howManySliced++;
            float _slicePercent = (float)howManySliced / (float)sliceCount;
            float _forBlendShape = _slicePercent * 100f;

            slicedFoodRenderer.SetBlendShapeWeight(0, _forBlendShape);

            sliceSpawner.transform.localPosition = Vector3.Lerp(sliceSpawnerStartPosition, sliceSpawnerEndPosition.localPosition, _slicePercent);

            boxCollider.center = Vector3.Lerp(boxColliderStartCenter, boxColliderEndCenter, _slicePercent);
            boxCollider.size = Vector3.Lerp(boxColliderStartSize, boxColliderEndSize, _slicePercent);

            //Instansiate food prefab
            Food _instantizedFood = Instantiate(slicePrefab, sliceSpawner.position, sliceSpawner.rotation);

            //Set cooked and fryed percent
            _instantizedFood.SetCookedAndFryedPercent(food.VertexAvarageRedValue(), food.VertexAvarageGreenValue());

            //Calculate center off mass again
            food.RecalculateCenterOffMass();
        }
    }
}