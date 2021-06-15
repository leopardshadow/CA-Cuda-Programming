# CA Project

## 題目

康威生命遊戲 (Conway's Game of Life)

## 環境

### 使用電腦

* 20.04.1 LTS (Focal Fossa)
* nvcc release 10.1, V10.1.243
* CPU: Intel i7-7700 CPU @ 3.60GHz
* GPU: Nvidia GeForce GTX 1050

### 編譯

根據下面幾種情況其中一種選擇輸入的指令。

```bash
# compute by CPU
$ nvcc main.cu

# compute by GPU different 
$ nvcc main.cu device1.cu
$ nvcc main.cu device2.cu
$ nvcc main.cu device3.cu
$ nvcc main.cu device4.cu
```

不論哪一種都會產生 `a.out` 檔案，透過下面指令執行並印出結果。

```bash
$ ./a.out
```

## 檔案說明

* main.cu: 包含 main function、設定初始值、顯示結果等
* host.h: 使用 CPU 順序得運算，用於和 GPU 版本程式比較速度
* device1.cu: 使用 GPU 平行運算的版本，切割方式見下一小節
* device2.cu: 使用 GPU 平行運算的版本，切割方式見下一小節

## 演算法內容

在二維矩形的世界中，每個方格住著一個細胞，細胞處於活著或死去其中一個狀態。下一個時刻細胞的死活由這一時刻它周圍的 8 個細胞所決定，規則如下:

* 目前細胞為存活狀態，周圍有 2 個 或 3 個活細胞: 細胞維持存活
* 目前細胞為存活狀態，周圍有小於 2 個 或大於 3 個活細胞: 細胞死去
* 目前細胞為死亡狀態，周圍恰有 3 個活細胞: 細胞存活
* 目前細胞為死亡狀態，周圍活細胞數量不為 3: 細胞維持死去

將上述規則畫成有限狀態機:



## 切割方式

這裡實做了四種分割方式，這裡以 8x8 的二維矩形世界為例，grid 和 block 大小都是 2。不同顏色代表分別由不同的 thread 處理。



雖然這裡用二維矩陣繪圖，但實做是使用一維陣列，原本二維矩陣對應的 i, j 經變換後對應到一維陣列。如果將其繪出會是以下樣子。這裡只畫前 16 個。另外，在實做時，我在二維矩形外有加一圈邊邊，其細胞狀態一直都維持死亡，不用更新他的狀態，這樣原本邊邊角角的細胞才不用做特殊處理，這裡沒畫出這個部份。

<img src="Screenshot 2021-06-15 124625.png" alt="Screenshot 2021-06-15 12:46:25" style="zoom:67%;" />

## 模擬結果

### 結果比較



