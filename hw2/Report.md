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
* host.h: 使用 CPU 順序地運算
* device1.cu: 使用 GPU 平行運算的版本，切割方式見下一小節
* device2.cu: 使用 GPU 平行運算的版本，切割方式見下一小節

## 演算法內容



## 切割方式

### device1.cu


### device2.cu


## 模擬結果



