import Image from 'next/image'
import icon from '../../public/black-boxes.png'

export default function DropImage() {
  return (
    <div className="w-80 p-4 mb-4 rounded-lg">
      <Image
        src={icon} 
        alt="Claim NFT" />
    </div>
  );
}
