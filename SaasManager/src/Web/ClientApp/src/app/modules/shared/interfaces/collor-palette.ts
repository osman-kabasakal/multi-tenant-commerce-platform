export interface ColorPalette {
  default:{
    primary: string;
    secondary: string;
    accent: string;
  },
  gradient: {
    from: string;
    via: string;
    to: string;
  };
  text: {
    primary: string;
    secondary: string;
    subtitle: string;
    title: string;
    heroTitle:string;
  };
  card: {
    background: string;
    border: string;
    text: string;
    icon: string;
  };
  button: {
    primary: {
      background: string;
      text: string;
      hover: string;
    };
    secondary: {
      border: string;
      text: string;
      hover: string;
    };
  };
}
