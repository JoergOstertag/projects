#ifndef _SD_CARD_WRITE
#define _SD_CARD_WRITE

#include "SdFat.h"

// Interrims import
#include "resultStorageHandler.h"

void sdCardWrite(ResultStorageHandler &resultStorageHandler);
void initSdCard();
File sdOpen(String fileName);

#endif
