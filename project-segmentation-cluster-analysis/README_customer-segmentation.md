# Mixed-Data Customer Segmentation with Ensemble Clustering

**Goal:** Segment customers using a mixed-type dataset (categorical + numerical) using an ensemble approach.  
**Key Techniques:** Multiple Correspondence Analysis (MCA), Agglomerative Hierarchical Clustering, k-Prototypes.  
**Tools:** Python (Jupyter), SAS JMP, Pandas, Scikit-learn, kmodes library.  
**Confidentiality Note:** The original data is proprietary; this notebook uses simulated data to demonstrate methods.

---

## Highlights

- 📊 Used **MCA** to reduce dimensionality of high-cardinality categorical features (e.g., customer type: 150+ levels)
- 🌱 Created an **intermediate customer classification layer** for more interpretable segmentation
- 🔀 Applied **k-Prototypes**, enabling clustering across mixed data types
- 📎 Integrated **agglomerative clustering** + **elbow method** to define optimal `k`

---

## Files

- `customer-segmentation.ipynb` — Annotated notebook with step-by-step clustering
- `README.md` — Project summary and key takeaways
- `mca-biplot.png` — Visual output of the MCA results
- `segmentation-methodology.pdf` — Detailed explanation of clustering logic and decision process
