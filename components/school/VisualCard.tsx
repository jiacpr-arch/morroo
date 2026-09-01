import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ImageIcon, FileText } from "lucide-react";
import type { SchoolVisual } from "@/lib/types-school";

interface Props {
  visual: SchoolVisual;
}

const LAYER_BADGE: Record<string, string> = {
  anatomy: "bg-rose-100 text-rose-700",
  physio: "bg-sky-100 text-sky-700",
  biochem: "bg-amber-100 text-amber-700",
  path: "bg-purple-100 text-purple-700",
  pharm: "bg-emerald-100 text-emerald-700",
  clinical: "bg-orange-100 text-orange-700",
  foundation: "bg-slate-100 text-slate-700",
};

export default function VisualCard({ visual }: Props) {
  return (
    <Link href={`/school/visual/${visual.id}`}>
      <Card className="h-full hover:shadow-md hover:border-fuchsia-300 transition-all cursor-pointer overflow-hidden">
        {visual.image_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={visual.image_url}
            alt={visual.title}
            className="w-full aspect-video object-cover bg-muted"
          />
        ) : (
          <div className="w-full aspect-video bg-gradient-to-br from-fuchsia-50 to-violet-50 flex items-center justify-center">
            <FileText className="h-10 w-10 text-fuchsia-300" />
          </div>
        )}
        <CardContent className="p-3 space-y-1">
          <div className="flex items-center gap-1 flex-wrap">
            <Badge
              className={LAYER_BADGE[visual.layer] ?? "bg-slate-100 text-slate-700"}
              variant="secondary"
            >
              {visual.layer}
            </Badge>
            {visual.school_topics && (
              <Badge variant="outline" className="text-xs">
                Y{visual.school_topics.year}
              </Badge>
            )}
            {visual.image_url ? (
              <ImageIcon className="h-3 w-3 text-muted-foreground ml-auto" />
            ) : (
              <FileText className="h-3 w-3 text-muted-foreground ml-auto" />
            )}
          </div>
          <p className="font-semibold text-sm line-clamp-2">{visual.title}</p>
          {visual.caption && (
            <p className="text-xs text-muted-foreground line-clamp-2">
              {visual.caption}
            </p>
          )}
        </CardContent>
      </Card>
    </Link>
  );
}
