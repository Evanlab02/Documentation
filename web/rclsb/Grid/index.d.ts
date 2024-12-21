import { PropsWithChildren } from '../../node_modules/react';
export declare function Grid(props: Readonly<PropsWithChildren>): import("react/jsx-runtime").JSX.Element;
export interface GridItemProps extends PropsWithChildren {
    xs?: number;
    sm?: number;
    md?: number;
    lg?: number;
    xl?: number;
    xxl?: number;
}
export declare function GridItem(props: Readonly<GridItemProps>): import("react/jsx-runtime").JSX.Element;
