import{j as e}from"./jsx-runtime-WdPq8kIh.js";import{c as u,I as c,S as x}from"./IconButton-i3pEjiHu.js";import{T as p}from"./index-Bsd7NUgv.js";import{r as l}from"./index-BpYrhlGc.js";/**
 * @license lucide-react v0.469.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const k=u("Menu",[["line",{x1:"4",x2:"20",y1:"12",y2:"12",key:"1e0a9i"}],["line",{x1:"4",x2:"20",y1:"6",y2:"6",key:"1owob3"}],["line",{x1:"4",x2:"20",y1:"18",y2:"18",key:"yk5zj1"}]]);function o(n){const{header:s,onMenuCallback:a,onThemeCallback:t}=n;return e.jsxs("header",{className:"lab-navigation-bar",children:[e.jsxs("div",{className:"lab-nav-item",children:[e.jsx(c,{onClickCallback:a,children:e.jsx(k,{height:20,width:20})}),e.jsx("h2",{className:"lab-nav-header",children:s})]}),e.jsx("div",{className:"lab-nav-item",children:e.jsx(c,{onClickCallback:t,children:e.jsx(x,{height:20,width:20})})})]})}o.__docgenInfo={description:"",methods:[],displayName:"NavBar"};const g={title:"NavBar",component:o,tags:["autodocs"]},j=n=>{const[s,a]=l.useState("dark"),t=l.useCallback(()=>{a(h=>h=="dark"?"light":"dark")},[a]);return e.jsx(p,{mode:s,children:e.jsx(o,{onThemeCallback:t,...n})})},r={args:{header:"React components"},render:j};var d,i,m;r.parameters={...r.parameters,docs:{...(d=r.parameters)==null?void 0:d.docs,source:{originalSource:`{
  args: {
    header: "React components"
  },
  render: DefaultRender
}`,...(m=(i=r.parameters)==null?void 0:i.docs)==null?void 0:m.source}}};const C=["Default"];export{r as Default,C as __namedExportsOrder,g as default};
