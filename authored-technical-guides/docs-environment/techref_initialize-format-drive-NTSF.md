# Seagate 2TB Drive – Initialization & Formatting Guide (Xbox Game Capture)

>_Prepared by: Ayana Andrews-Joseph | J&E Consultants_

**Goal:** Prepare a 2TB Seagate external hard drive for Xbox Series S game recording by initializing and formatting it to NTFS.

---

## 🧩 Scenario

- Drive is not recognized in File Explorer  
- Appears as `Unknown` and `Unallocated` in Disk Management  
- Needs to be formatted for NTFS to enable Xbox recordings longer than 2 minutes

---

## 🛠️ Step-by-Step Guide

### 1. Verify Physical Connection

- Ensure the USB cable is working and firmly connected  
- Test with another USB port or computer to confirm the drive powers on

---

### 2. Open Disk Management

- Press `Win + X` and select **Disk Management**  
- Wait for the system to load all connected drives

---

### 3. Identify the External Drive

- Look for a disk listed as:
  - `Disk 2` (or higher)
  - Size around **1863.02 GB** for a 2TB drive
  - Status: **Unknown** and **Unallocated**
- Confirm this is not your system drive (usually Disk 0)

---

### 4. Initialize the Disk

- Right-click the gray label on the left side of **Disk 2**
- Select **Initialize Disk**
- Choose **GPT (GUID Partition Table)** as the partition style  
  ✅ GPT supports large volumes and modern systems  
  ❌ Do not use MBR unless explicitly required

---

### 5. Create a New Simple Volume

- Right-click on the **Unallocated space**
- Choose **New Simple Volume**
- Use the full available size
- Assign a drive letter (e.g., E:, F:)
- Format settings:
  - **File System:** NTFS
  - **Allocation Unit Size:** Default
  - **Volume Label:** GameDrive (optional)
  - ✅ Check **Perform a quick format**
  - ❌ Uncheck **Enable file and folder compression**

---

### 6. Verify the Drive

- The new partition will appear with a **blue bar** in Disk Management  
- File Explorer should now show the new drive  
- Confirm the capacity and label are correct

---

## 💡 Notes

- Xbox Series S requires NTFS to allow full-length captures  
- exFAT may work but is not preferred for high-performance video writes  
- If the drive still doesn’t show on Xbox, try reformatting on the console or with exFAT  
- Compression should remain off to avoid performance degradation

---

## 🧾 Created By

**Ayana | J&E Consultants**  
May 3, 2025 | GitHub Markdown Technical Series
