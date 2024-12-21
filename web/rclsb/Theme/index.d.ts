import { PropsWithChildren } from '../../node_modules/react';
export interface ThemeProviderProps extends PropsWithChildren {
    mode: "dark" | "light";
}
export default function ThemeProvider(props: Readonly<ThemeProviderProps>): import("react/jsx-runtime").JSX.Element;
