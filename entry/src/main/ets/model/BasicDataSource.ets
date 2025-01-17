import { IHousePictureList } from "./RentRoomData";

export class BasicDataSource<T>  implements IDataSource {
  private listeners: DataChangeListener[] = [];

    data:Array<T> = [];
  constructor() {

  }

  totalCount(): number {
    return this.data.length;
  }

  getData(index: number): T {
    return this.data[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }


  pushDataList(list:Array<T> ) {

    this.data.push(...list);
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }
}

export interface BasicDataItem {
  "url": string
  "currentTabIndex": number
}