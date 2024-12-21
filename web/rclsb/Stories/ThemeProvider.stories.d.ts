import { StoryObj } from '@storybook/react';
import { default as ThemeProvider } from '../Theme';
declare const meta: {
    title: string;
    component: typeof ThemeProvider;
    argTypes: {
        mode: {
            description: string;
            name: string;
            control: "radio";
            options: string[];
            type: "string";
        };
    };
    tags: string[];
};
export default meta;
type Story = StoryObj<typeof meta>;
export declare const Default: Story;
