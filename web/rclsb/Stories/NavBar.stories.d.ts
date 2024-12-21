import { StoryObj } from '@storybook/react';
import { default as NavBar } from '../NavBar';
declare const meta: {
    title: string;
    component: typeof NavBar;
    tags: string[];
};
export default meta;
type Story = StoryObj<typeof meta>;
export declare const Default: Story;
