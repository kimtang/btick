import { Injectable } from '@angular/core';

import { webSocket } from 'rxjs/webSocket';
import { catchError, tap, switchAll } from 'rxjs/operators';
import { EMPTY, Subject } from 'rxjs';
import { serialize, deserialize } from './c';

@Injectable({
  providedIn: 'root'
})
export class WebSocketService {
  public socket$ =  webSocket({  
    binaryType: 'arraybuffer',
    serializer:serialize,
    deserializer:v => deserialize(v.data),
    'url': 'ws://localhost:9065'
  });

  constructor() {}
}
