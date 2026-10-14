import {ColorPalette} from '../../../../../shared/interfaces/collor-palette';

const defaultPalette:ColorPalette={
  default:{
    primary: '#4F46E5',    // Ana renk
    secondary: '#818CF8',  // İkincil renk
    accent: '#C7D2FE',     // Vurgu rengi
  },
  gradient: {
    from: '#4F46E5',    // Gradient başlangıç
    via: '#6366F1',     // Gradient orta
    to: '#818CF8'       // Gradient bitiş
  },
  text: {
    primary: '#FFFFFF',   // Ana metin rengi
    secondary: '#E0E7FF',  // İkincil metin rengi
    subtitle: '#6C757D',
    title: '#6C757D',
    heroTitle:'#6C757D',
  },
  card: {
    background: 'rgba(79, 70, 229, 0.1)',  // Kart arka plan
    border: 'rgba(99, 102, 241, 0.2)',     // Kart kenarlık
    text: '#E0E7FF',                       // Kart metin
    icon: '#818CF8'                        // Kart ikon
  },
  button: {
    primary: {
      background: '#FFFFFF',
      text: '#4F46E5',
      hover: '#E0E7FF'
    },
    secondary: {
      border: '#E0E7FF',
      text: '#FFFFFF',
      hover: 'rgba(99, 102, 241, 0.2)'
    }
  }
};

const palette1:ColorPalette={
  default:{
    primary: '#7C3AED',
    secondary: '#C084FC',
    accent: '#F5D0FE',
  },
  gradient: {
    from: '#7C3AED',
    via: '#9333EA',
    to: '#C084FC'
  },
  text: {
    primary: '#FFFFFF',
    secondary: '#F5D0FE',
    subtitle: '#6C757D',
    title: '#6C757D',
    heroTitle:'#6C757D',
  },
  card: {
    background: 'rgba(124, 58, 237, 0.1)',
    border: 'rgba(192, 132, 252, 0.2)',
    text: '#F5D0FE',
    icon: '#C084FC'
  },
  button: {
    primary: {
      background: '#FFFFFF',
      text: '#7C3AED',
      hover: '#F5D0FE'
    },
    secondary: {
      border: '#F5D0FE',
      text: '#FFFFFF',
      hover: 'rgba(192, 132, 252, 0.2)'
    }
  }
}

const palette2:ColorPalette={
  default:{
    primary: '#0EA5E9',
    secondary: '#22D3EE',
    accent: '#BAE6FD',
  },
  gradient: {
    from: '#0EA5E9',
    via: '#06B6D4',
    to: '#22D3EE'
  },
  text: {
    primary: '#FFFFFF',
    secondary: '#BAE6FD',
    subtitle: '#6C757D',
    title: '#6C757D',
    heroTitle:'#6C757D',
  },
  card: {
    background: 'rgba(14, 165, 233, 0.1)',
    border: 'rgba(34, 211, 238, 0.2)',
    text: '#BAE6FD',
    icon: '#22D3EE'
  },
  button: {
    primary: {
      background: '#FFFFFF',
      text: '#0EA5E9',
      hover: '#BAE6FD'
    },
    secondary: {
      border: '#BAE6FD',
      text: '#FFFFFF',
      hover: 'rgba(34, 211, 238, 0.2)'
    }
  }
}

const palette3: ColorPalette = {

  default: {
    primary: '#007BFF', // canlı ve güven veren bir mavi
    secondary: '#28A745', // modern ve dinamik bir yeşil
    accent: '#e37b47', // açık mavi aksan rengi
  },

  gradient: {
    from: '#007BFF', // ana mavi ton
    via: '#00C9A7', // geçiş için taze ve canlı yeşil ton
    to: '#28A745', // yeşil ile bitiş
  },

  text: {
    primary: '#1E212B', // koyu gri, profesyonel görünüm
    secondary: '#c32065', // açık gri, temiz ve minimal
    subtitle: '#cddc45',
    title: '#6C757D',
    heroTitle:'#e9eef1',
  },

  card: {
    background: 'rgba(0, 123, 255, 0.1)', // açık mavi transparan arka plan
    border: 'rgba(0, 201, 167, 0.2)', // yumuşak yeşil sınır
    text: '#1E212B', // kart içindeki koyu gri metin
    icon: '#28A745', // kart simgeleri için yeşil
  },

  button: {
    primary: {
      background: '#007BFF', // butonlar için güçlü mavi
      text: '#FFFFFF', // beyaz metin
      hover: '#0056b3', // koyu mavi hover efekti
    },
    secondary: {
      border: '#28A745', // yeşil sınır
      text: '#FFFFFF', // beyaz metin
      hover: 'rgba(0, 201, 167, 0.2)', // yeşil transparan hover efekti
    },
  },
};


export const palletes={
  defaultPalette,
  palette1,
  palette2,
  palette3
};
