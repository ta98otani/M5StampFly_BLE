/*
 * MIT License
 *
 * Copyright (c) 2025 Takuya Otani
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef BLE_HANDLER_HPP
#define BLE_HANDLER_HPP

#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define SERVICE_UUID        "1a8e4e30-def4-4d96-a1f4-7e6101b7eea4"
#define CHARACTERISTIC_UUID  "8f9a9bc0-2bdd-40dd-8bb5-cb9d4e3799ff"

class BLEHandler {
public:
    BLEHandler();
    void initBLE();
    void sendSensorData();
    bool isDeviceConnected();
    
private:
    BLEServer* pServer;
    BLECharacteristic* pCharacteristic;
    bool deviceConnected;
    
    // Callback classes require reference to BLEHandler instance
    class MyServerCallbacks : public BLEServerCallbacks {
    public:
        MyServerCallbacks(BLEHandler& handler) : handler(handler) {}
        void onConnect(BLEServer* pServer) override;
        void onDisconnect(BLEServer* pServer) override;
    private:
        BLEHandler& handler;
    };

    class MyCallbacks : public BLECharacteristicCallbacks {
    public:
        MyCallbacks(BLEHandler& handler) : handler(handler) {}
        void onWrite(BLECharacteristic* pCharacteristic) override;
    private:
        BLEHandler& handler;
    };

    friend class MyServerCallbacks;
    friend class MyCallbacks;
};

#endif // BLE_HANDLER_H
