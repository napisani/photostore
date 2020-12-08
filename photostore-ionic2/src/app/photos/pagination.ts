export interface Pagination<T> {
  items: Array<T>;
  itemSlices: Array<Array<T>>;
  perPage: number;
  total: number;
  page: number;
  remainingPages: number;
}


export const calculateRemainingPages = (total: number, current: number, perPage: number) => {
  const count = perPage * current * 1.0;
  if (perPage === 0) {
    return 0;
  }
  const pagesLeft = Math.ceil((total - count) / perPage);
  return pagesLeft;
};


export const reducePagination = <T>(acc: Pagination<T>, cur: Pagination<T>): Pagination<T> => {
  acc.remainingPages = Math.min(cur.remainingPages, acc.remainingPages);
  acc.page = Math.max(cur.page, acc.page);
  acc.items = [...acc.items, ...cur.items];
  acc.itemSlices = [...acc.itemSlices, cur.items];
  // while(acc.itemSlices.length > 3){
  //     acc.itemSlices.shift()
  // }
  return Object.assign({}, acc);
};


export const reducePagination2 = <T>(acc: Pagination<T>, cur: Pagination<T>): Pagination<T> => {
  acc.remainingPages = Math.min(cur.remainingPages, acc.remainingPages);
  acc.page = Math.max(cur.page, acc.page);
  acc.items = [...acc.items, ...cur.items];
  acc.itemSlices = [...acc.itemSlices, cur.items];
  return Object.assign({}, acc);
};
