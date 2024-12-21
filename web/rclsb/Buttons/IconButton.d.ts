import { PropsWithChildren } from '../../node_modules/react';
export interface IconButtonProps extends PropsWithChildren {
    onClickCallback?: () => void;
}
export default function IconButton(props: Readonly<IconButtonProps>): import("react/jsx-runtime").JSX.Element;
