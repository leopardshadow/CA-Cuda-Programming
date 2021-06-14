# CA Project

## 題目

康威生命遊戲 (Conway's Game of Life)

## 環境

### 硬體

* CPU:
* GPU: 

### 編譯

根據下面三種情況其中一種選擇輸入的指令。

```bash
# compute by CPU
$ nvcc main.cu

# compute by GPU using way 1
$ nvcc main.cu device1.cu

# compute by GPU using way 2
$ nvcc main.cu device2.cu
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

![](https://i.imgur.com/pvvH4sp.png)

### device1.cu



### device2.cu



## 模擬結果



