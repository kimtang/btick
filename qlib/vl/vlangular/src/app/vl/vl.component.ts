import { Component, OnInit } from '@angular/core';
import { WebSocketService } from '../websocket.service';
import vegaEmbed from "vega-embed";



@Component({
  selector: 'app-vl',
  templateUrl: './vl.component.html',
  styleUrls: ['./vl.component.css']
})

export class VlComponent implements OnInit {

  constructor(public webSocket:WebSocketService) { }

  jobject = null; 

  ngOnInit(): void {
    this.webSocket.socket$.next([".vl.register",[]]);
    this.webSocket.socket$.subscribe(
      (msg) =>{
        if(msg.hasOwnProperty('vg')){this.jobject=null;vegaEmbed('#vis', msg['vg']);}
        if(msg.hasOwnProperty('json')){this.jobject= msg['json'];vegaEmbed('#vis', {});}
      }
      );

    

  };

}
