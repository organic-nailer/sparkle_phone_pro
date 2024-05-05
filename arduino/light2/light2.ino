#define BAUD_RATE 56700

#include <FastLED.h>
#define LED_PIN 7
#define NUM_LEDS 100
#define BRIGHTNESS 20
#define LED_TYPE WS2812B
#define COLOR_ORDER GRB
CRGB leds[NUM_LEDS];

int data;

int color[NUM_LEDS][3];
int lightness[NUM_LEDS];
int cursor = 0;

void setup() {
    delay(3000);
    pinMode( 13, OUTPUT );
    Serial.begin(BAUD_RATE);
    Serial.setTimeout(100);
    FastLED.addLeds<LED_TYPE, LED_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
    FastLED.setBrightness(BRIGHTNESS);
    for (int i = 0; i < NUM_LEDS; i++) {
        color[i][0] = 0;
        color[i][1] = 0;
        color[i][2] = 0;
        lightness[i] = 0;
    }
}

void turnOn(int length) {
    for (int i = 0; i < NUM_LEDS; i++) {
        if (i < length && i > length - 10) {
            leds[i] = CRGB(255, 255, 255);
        } else {
            leds[i] = CRGB(0, 0, 0);
        }
    }
    FastLED.show();
}

// void loop() {
//     if (Serial.available() > 0) {
//         data = Serial.read();
//         turnOn(data);
//         Serial.write(data);
//         Serial.flush();
//     }
// }

void turnOnList() {
    for (int i = 0; i < 66; i++) {
        leds[i] = CRGB(color[i][0], color[i][1], color[i][2]);
        // leds[i] = CRGB(
        //     color[i][0], 
        //     color[i][1], 
        //     color[i][2]
        // );
    }
    FastLED.show();
}

// void loop() {
//     if (Serial.available() > 0) {
//         data = Serial.read();
//         if (data >> 6 > 0) {
//             turnOnList();
//             cursor = 0;
//         } else {
//             lightness[cursor] = data;
//             color[cursor][0] = (data & 3) * 85;
//             color[cursor][1] = ((data >> 2) & 3) * 85;
//             color[cursor][2] = ((data >> 4) & 3) * 85;
//             cursor++;
//         }
//         // if ((data >> 6) > 0) {
//         //     turnOnList();
//         //     cursor = 0;
//         // } else {
//         //     color[cursor][0] = data & 0b00000011;
//         //     color[cursor][1] = (data & 0b00001100) >> 2;
//         //     color[cursor][2] = (data & 0b00110000) >> 4;
//         //     cursor++;
//         // }
//     }
// }

uint8_t buffer[51];

void loop() {
    if (Serial.available() > 0) {
        size_t res = Serial.readBytes(buffer, 51);
        if (res < 51) {
            digitalWrite( 13, LOW );
            return;
        };
        for (int i = 0; i < 17; i++) {
            color[i * 4 + 0][0] = ((buffer[i * 3 + 0] & 0b00000011) >> 0) * 85;
            color[i * 4 + 1][0] = ((buffer[i * 3 + 0] & 0b00001100) >> 2) * 85;
            color[i * 4 + 2][0] = ((buffer[i * 3 + 0] & 0b00110000) >> 4) * 85;
            color[i * 4 + 3][0] = ((buffer[i * 3 + 0] & 0b11000000) >> 6) * 85;
            color[i * 4 + 0][1] = ((buffer[i * 3 + 1] & 0b00000011) >> 0) * 85;
            color[i * 4 + 1][1] = ((buffer[i * 3 + 1] & 0b00001100) >> 2) * 85;
            color[i * 4 + 2][1] = ((buffer[i * 3 + 1] & 0b00110000) >> 4) * 85;
            color[i * 4 + 3][1] = ((buffer[i * 3 + 1] & 0b11000000) >> 6) * 85;
            color[i * 4 + 0][2] = ((buffer[i * 3 + 2] & 0b00000011) >> 0) * 85;
            color[i * 4 + 1][2] = ((buffer[i * 3 + 2] & 0b00001100) >> 2) * 85;
            color[i * 4 + 2][2] = ((buffer[i * 3 + 2] & 0b00110000) >> 4) * 85;
            color[i * 4 + 3][2] = ((buffer[i * 3 + 2] & 0b11000000) >> 6) * 85;
        }
        turnOnList();
        digitalWrite( 13, HIGH );
    }
}
