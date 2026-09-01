"use client";

// ถาดเครื่องมือ — select-then-act: แตะเลือกก่อนแล้วค่อยลงมือบนเวที
// ปุ่มใหญ่พอสำหรับนิ้วโป้ง เลื่อนแนวนอนได้บนจอแคบ

import { TOOL_CATALOG, type ToolId } from "@/lib/resus/types";

interface ToolTrayProps {
  tools: ToolId[];
  activeTool: ToolId | null;
  showHints: boolean;
  onSelect: (tool: ToolId) => void;
}

export default function ToolTray({ tools, activeTool, showHints, onSelect }: ToolTrayProps) {
  return (
    <div className="rss-tray" role="toolbar" aria-label="ถาดเครื่องมือ">
      {tools.map((id) => {
        const tool = TOOL_CATALOG[id];
        const on = activeTool === id;
        return (
          <button
            key={id}
            type="button"
            className={`rss-tool ${on ? "rss-tool-on" : ""}`}
            onClick={() => onSelect(id)}
            aria-pressed={on}
            data-testid={`tool-${id}`}
            title={showHints ? tool.hint : undefined}
          >
            <span className="rss-tool-emoji" aria-hidden>{tool.emoji}</span>
            <span className="rss-tool-name">{tool.name}</span>
          </button>
        );
      })}
    </div>
  );
}
