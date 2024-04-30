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
    Serial.begin(BAUD_RATE);
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
    for (int i = 0; i < NUM_LEDS; i++) {
        leds[i] = CRGB(color[i][0], color[i][1], color[i][2]);
        // leds[i] = CRGB(
        //     color[i][0], 
        //     color[i][1], 
        //     color[i][2]
        // );
    }
    FastLED.show();
}

void loop() {
    if (Serial.available() > 0) {
        data = Serial.read();
        if (data >> 6 > 0) {
            turnOnList();
            cursor = 0;
        } else {
            lightness[cursor] = data;
            color[cursor][0] = (data & 3) * 85;
            color[cursor][1] = ((data >> 2) & 3) * 85;
            color[cursor][2] = ((data >> 4) & 3) * 85;
            cursor++;
        }
        // if ((data >> 6) > 0) {
        //     turnOnList();
        //     cursor = 0;
        // } else {
        //     color[cursor][0] = data & 0b00000011;
        //     color[cursor][1] = (data & 0b00001100) >> 2;
        //     color[cursor][2] = (data & 0b00110000) >> 4;
        //     cursor++;
        // }
    }
}
