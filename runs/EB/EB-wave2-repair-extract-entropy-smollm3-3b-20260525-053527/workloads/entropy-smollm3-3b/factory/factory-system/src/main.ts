import { Station, Product, Routing } from './station';
import { Component } from './component';
import { StationComponent } from './station-component';
import { ProductComponent } from './product-component';
import { RoutingComponent } from './routing-component';
import { StationService } from './station.service';
import { ProductService } from './product.service';
import { RoutingService } from './routing.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'Factory';

  stations: Station[] = [];
  products: Product[] = [];
  routings: Routing[] = [];

  constructor(private stationService: StationService, private productService: ProductService, private routingService: RoutingService) {
    this.stationService.getStations().subscribe(stations => this.stations = stations);
    this.productService.getProducts().subscribe(products => this.products = products);
    this.routingService.getRoutings().subscribe(routings => this.routings = routings);
  }
}
