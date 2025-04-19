# 📊 Visual Assessment of the Training Dataset

![Representation of Data Between Sets](ae907b1d-9c6d-41a5-8a6e-1820f6ebf14b.png)

### 🧠 Why This Matters

Before diving into modeling, it’s critical to visualize not just the **full dataset**, but also your **training and test splits**. The visualization above breaks it down into three views:

- **Full Data**: The raw historical average price across multiple years  
- **Split Data**: A closer look at how slicing changes representation  
- **Final Train Set (80/20)**: The training data used for modeling

Each subset carries forward — or potentially **loses** — key patterns from the original data.

> **Takeaway**: Assessing your data splits visually ensures your training set is representative, not skewed. This helps avoid bias, overfitting, and inaccurate generalization.

✅ **Visual check = sanity check.**
